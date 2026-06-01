
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Tutores.UseCases;


namespace STEMMA.Application.Cadastro.Tutores.Services;

public class TutorService : ITutorService
{
    private readonly ICreateTutorUseCase _createTutorUseCase;
    private readonly GetTutorByIdUseCase _getTutorByIdUseCase;
    private readonly ListTutorsUseCase _listTutorsUseCase;
    private readonly UpdateTutorUseCase _updateTutorUseCase;
    private readonly DeleteTutorUseCase _deleteTutorUseCase;

    public TutorService(
        ICreateTutorUseCase createTutorUseCase,
        GetTutorByIdUseCase getTutorByIdUseCase,
        ListTutorsUseCase listTutorsUseCase,
        UpdateTutorUseCase updateTutorUseCase,
        DeleteTutorUseCase deleteTutorUseCase)
    {
        _createTutorUseCase = createTutorUseCase;
        _getTutorByIdUseCase = getTutorByIdUseCase;
        _listTutorsUseCase = listTutorsUseCase;
        _updateTutorUseCase = updateTutorUseCase;
        _deleteTutorUseCase = deleteTutorUseCase;
    }

    public async Task<Guid> CriarAsync(
    CreateTutorRequest request)
{
    return await _createTutorUseCase.ExecuteAsync(request);
}

    public async Task<TutorResponse> ObterPorIdAsync(Guid id)
    {
        return await _getTutorByIdUseCase.ExecuteAsync(id);
    }

    public async Task<List<TutorResponse>> ListarAsync()
    {
        return await _listTutorsUseCase.ExecuteAsync();
    }

    public async Task<TutorResponse> AtualizarAsync(
        Guid id,
        UpdateTutorRequest request)
    {
        return await _updateTutorUseCase.ExecuteAsync(id, request);
    }

    public async Task RemoverAsync(Guid id)
    {
        await _deleteTutorUseCase.ExecuteAsync(id);
    }
}