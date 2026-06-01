using STEMMA.Application.Cadastro.DTOs.Requests;

namespace STEMMA.Application.Cadastro.Tutores.UseCases;

public interface ICreateTutorUseCase
{
    Task<Guid> ExecuteAsync(CreateTutorRequest request);
}