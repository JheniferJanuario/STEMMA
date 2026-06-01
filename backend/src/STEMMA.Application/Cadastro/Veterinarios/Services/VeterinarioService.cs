using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;
using STEMMA.Application.Cadastro.Veterinarios.UseCases;

namespace STEMMA.Application.Cadastro.Veterinarios.Services;

public class VeterinarioService : IVeterinarioService
{
    private readonly ICreateVeterinarioUseCase _createVeterinarioUseCase;
    private readonly GetVeterinarioByIdUseCase _getVeterinarioByIdUseCase;
    private readonly ListVeterinariosUseCase _listVeterinariosUseCase;
    private readonly UpdateVeterinarioUseCase _updateVeterinarioUseCase;
    private readonly DeleteVeterinarioUseCase _deleteVeterinarioUseCase;

    public VeterinarioService(
        ICreateVeterinarioUseCase createVeterinarioUseCase,
        GetVeterinarioByIdUseCase getVeterinarioByIdUseCase,
        ListVeterinariosUseCase listVeterinariosUseCase,
        UpdateVeterinarioUseCase updateVeterinarioUseCase,
        DeleteVeterinarioUseCase deleteVeterinarioUseCase)
    {
        _createVeterinarioUseCase = createVeterinarioUseCase;
        _getVeterinarioByIdUseCase = getVeterinarioByIdUseCase;
        _listVeterinariosUseCase = listVeterinariosUseCase;
        _updateVeterinarioUseCase = updateVeterinarioUseCase;
        _deleteVeterinarioUseCase = deleteVeterinarioUseCase;
    }

    public async Task<Guid> CriarAsync(CreateVeterinarioRequest request)
    {
        return await _createVeterinarioUseCase.ExecuteAsync(request);
    }

    public async Task<VeterinarioResponse> ObterPorIdAsync(Guid id)
    {
        return await _getVeterinarioByIdUseCase.ExecuteAsync(id);
    }

    public async Task<List<VeterinarioResponse>> ListarAsync()
    {
        return await _listVeterinariosUseCase.ExecuteAsync();
    }

    public async Task<VeterinarioResponse> AtualizarAsync(
        Guid id,
        UpdateVeterinarioRequest request)
    {
        return await _updateVeterinarioUseCase.ExecuteAsync(id, request);
    }

    public async Task RemoverAsync(Guid id)
    {
        await _deleteVeterinarioUseCase.ExecuteAsync(id);
    }
}